(in-ns 'user)

(require '[clj-reload.core :as reload])
(require '[malli.dev :as dev])
(require '[clojure.string :as str])
(require '[clojure.java.io :as io])
(require '[clojure.pprint :as pprint])

(def m2-dir
  (str (System/getenv "HOME") "/.m2"))

(def classpath
  (into #{}
        (comp
         (filter (fn [path]
                   (not (str/starts-with? path m2-dir))))
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

(reload/init {:dirs classpath})

(add-tap
 (bound-fn*
  (fn [data]
    (binding [*out* (java.io.PrintWriter. (java.io.OutputStreamWriter. System/out))]
      (pprint/pprint data)))))

(defn instrument! []
  #_(binding [*out* (java.io.PrintWriter. (java.io.OutputStreamWriter. System/out))]
      (dev/start!)))

(defn reload-namespaces []
  (reload/reload)
  (instrument!))

(instrument!)
