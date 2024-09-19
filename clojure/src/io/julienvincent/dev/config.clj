(ns io.julienvincent.dev.config
  (:require
   [clojure.java.io :as io]
   [clojure.edn :as edn]))

(defn get-local-config []
  (let [file (io/file "deps.local.edn")]
    (when (.exists file)
      (some->> (slurp file)
               (edn/read-string)
               :local/config))))

(defn get-binding [binding]
  (get-in (get-local-config) [:bindings binding]))
