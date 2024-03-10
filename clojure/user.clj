(in-ns 'user)

(require
 '[clj-reload.core :as reload]
 '[malli.dev :as dev]
 '[clojure.string :as str]
 '[clojure.edn :as edn]
 '[clojure.java.io :as io]
 '[puget.printer :as puget]
 '[clojure.math :as math]
 '[clj-commons.format.exceptions :as pretty.exceptions])

(import
 '[java.nio.file Paths]
 '[java.net URI])

(defn- get-local-config []
  (some->> (slurp "deps.local.edn")
           (edn/read-string)
           :local/config))

(defn- get-binding [binding]
  (get-in (get-local-config) [:bindings binding]))

#_{:clj-kondo/ignore [:clojure-lsp/unused-public-var]}
(defn restart-system []
  (if-let [sym (get-binding :restart!)]
    ((requiring-resolve sym))
    (println "No :restart! defined in project :local")))

#_{:clj-kondo/ignore [:clojure-lsp/unused-public-var]}
(defn stop-system []
  (if-let [sym (get-binding :stop!)]
    ((requiring-resolve sym))
    (println "No :stop! defined in project :local")))

(def ^:private m2-dir
  (str (System/getenv "HOME") "/.m2"))

(def ^:private gitlibs-dir
  (str (System/getenv "HOME") "/.gitlibs"))

(defn- is-parent [parent child]
  (let [parent (-> (Paths/get (URI. (str "file://" parent)))
                   .toAbsolutePath
                   .normalize)
        child (-> (Paths/get (URI. (str "file://" child)))
                  .toAbsolutePath
                  .normalize)]

    (.startsWith child parent)))

(defn- remove-parents [classpath]
  (->> classpath
       (sort-by identity (fn [left right]
                           (compare (count left) (count right))))
       (reduce
        (fn [paths path]
          (let [paths (filter
                       (fn [existing]
                         (not (is-parent existing path)))
                       paths)]
            (conj paths path)))
        [])))

(def ^:private classpath
  (into #{}
        (comp
         (filter (fn [path]
                   (and (not (str/starts-with? path m2-dir))
                        (not (str/starts-with? path gitlibs-dir)))))
         (filter (fn [path]
                   (let [file (io/file path)]
                     (and (.exists file)
                          (.isDirectory file)))))
         (filter (fn [path]
                   (not (some #{path} #{"dev" "local"}))))
         (map (fn [path]
                (->> (java.io.File. path)
                     .getAbsolutePath
                     str))))

        (str/split (System/getProperty "java.class.path") #":")))

(def ^:private puget-opts
  {:print-color true
   :color-scheme {:delimiter nil
                  :tag [:white]

                  :nil [:bold :black]
                  :boolean [:green]
                  :number [:magenta :bold]
                  :string [:bold :green]
                  :character [:bold :magenta]
                  :keyword [:bold :red]
                  :symbol [:white :bold]

                  :function-symbol [:bold :blue]
                  :class-delimiter [:blue]
                  :class-name [:bold :blue]}})

(add-tap
 (fn [data]
   (if (instance? Throwable data)
     (.println System/out (pretty.exceptions/format-exception data))
     (let [pretty-string (puget/pprint-str data puget-opts)]
       (.println System/out pretty-string)))))

(defn instrument! []
  (let [config (:instrumentation (get-local-config))
        {:keys [enable report]
         :or {enable true
              report :throw}} config

        report (if (set? report)
                 report
                 #{report})]

    (when enable
      (try
        (dev/start!
         {:report (fn [key data]
                    (when (:log report)
                      (tap> {:type key
                             :data data}))

                    (when (:throw report)
                      (throw (ex-info (str "Function "
                                           (:fn-name data)
                                           " schema not satisfied - "
                                           key)
                                      {:args (:args data)
                                       :type key
                                       :fn (:fn-name data)}))))})

        (catch Exception ex
          (tap> "Failed to initialize malli instrumentation")
          (tap> ex))))))

#_{:clj-kondo/ignore [:clojure-lsp/unused-public-var]}
(defn reload-namespaces []
  (reload/reload)
  (instrument!))

(instrument!)
(try
  (reload/init {:dirs (remove-parents classpath)})
  nil
  (catch Exception ex
    (tap> "Failed to initialize clj-reload")
    (tap> ex)))

#_{:clj-kondo/ignore [:clojure-lsp/unused-public-var]}
(defmacro with-time [name & body]
  `(let [start# (System/nanoTime)
         result# (do ~@body)
         end# (System/nanoTime)
         delta# (-> (- end# start#)
                    (/ 10000.0)
                    math/round
                    (/ 100.0))]
     (prn (str "Time [" ~name "]: " delta# "ms"))
     (tap> [~name, delta#])
     result#))

#_{:clj-kondo/ignore [:clojure-lsp/unused-public-var]}
(defn tap>> [& args]
  (doseq [arg args]
    (tap> arg))

  (last args))

nil
