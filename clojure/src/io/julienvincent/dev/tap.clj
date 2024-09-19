(ns io.julienvincent.dev.tap
  (:require
   [io.julienvincent.dev.pprint :as dev.pprint])
  (:import
   [java.io FileDescriptor FileOutputStream]))

(defn add-stdout-tap []
  (let [stdout (FileOutputStream. FileDescriptor/out)]
    (add-tap
     (fn [data]
       (dev.pprint/echo stdout data)))))
