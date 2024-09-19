(ns io.julienvincent.dev.config
  (:require
   [clojure.edn :as edn]
   [clojure.java.io :as io]))

(defn get-local-config []
  (let [file (io/file "deps.local.edn")]
    (when (.exists file)
      (some->> (slurp file)
               (edn/read-string)
               :local/config))))

(defn get-binding [binding]
  (get-in (get-local-config) [:bindings binding]))
