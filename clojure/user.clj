(in-ns 'user)

(require '[clj-reload.core :as reload])
(require '[malli.dev :as dev])
(require '[clojure.string :as str])
(require '[clojure.java.io :as io])
(require '[puget.printer :as puget])
(require '[clojure.math :as math])

(def ^:private m2-dir
  (str (System/getenv "HOME") "/.m2"))

(def ^:private gitlibs-dir
  (str (System/getenv "HOME") "/.gitlibs"))

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
   (let [pretty-string (puget/pprint-str data puget-opts)]
     (.println System/out pretty-string))))

(defn instrument! []
  #_(binding [*out* (java.io.PrintWriter. (java.io.OutputStreamWriter. System/out))]
      (dev/start!)))

#_{:clj-kondo/ignore [:clojure-lsp/unused-public-var]}
(defn reload-namespaces []
  (reload/reload)
  (instrument!))

(instrument!)
(reload/init {:dirs classpath})

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
