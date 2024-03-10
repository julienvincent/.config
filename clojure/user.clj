(in-ns 'user)

(require '[clj-reload.core :as reload])
(require '[malli.dev :as dev])
(require '[clojure.string :as str])
(require '[clojure.edn :as edn])
(require '[clojure.java.io :as io])
(require '[puget.printer :as puget])
(require '[clojure.math :as math])
(require '[clj-commons.format.exceptions :as pretty.exceptions])
(import '[java.nio.file Paths])
(import '[java.net URI])

(defn get-project-bindings []
  (some->> (slurp "deps.local.edn")
           (edn/read-string)
           :aliases
           :local
           :bindings))

(defn restart-system []
  (if-let [sym (:restart! (get-project-bindings))]
    ((requiring-resolve sym))
    (println "No :restart! defined in project :local")))

(defn stop-system []
  (if-let [sym (:stop! (get-project-bindings))]
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
  #_(binding [*out* (java.io.PrintWriter. (java.io.OutputStreamWriter. System/out))]
      (dev/start!)))

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

nil
