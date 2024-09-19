(ns io.julienvincent.dev.cp
  (:require
   [clojure.java.io :as io]
   [clojure.string :as str])
  (:import
   java.net.URI
   java.nio.file.Paths))

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
          (let [paths (filterv
                       (fn [existing]
                         (not (is-parent existing path)))
                       paths)]
            (conj paths path)))
        [])))

(defn collect-classpath []
  (remove-parents
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

         (str/split (System/getProperty "java.class.path") #":"))))
