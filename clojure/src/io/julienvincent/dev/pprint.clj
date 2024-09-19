(ns io.julienvincent.dev.pprint
  (:require
   [clj-commons.format.exceptions :as pretty.exceptions]
   [zprint.core :as zprint])
  (:import
   [java.io Writer OutputStream]))

(def ^:private opts
  {:map {:comma? false}
   :color-map {:brace [:white :bold],
               :bracket [:white :bold],
               :keyword [:red :bold]
               :char [:magenta],
               :comma [:white],
               :comment [:white],
               :deref [:bold :white],
               :true [:magenta :bold],
               :false [:magenta :bold],
               :fn [:bright-green],
               :hash-brace :white,
               :hash-paren :green,
               :left :white,
               :nil [:magenta],
               :none [:white],
               :number [:magenta :bold],
               :paren [:bold :white],
               :quote [:green],
               :regex [:green],
               :right :none,
               :string [:bright-green :bold],
               :symbol [:bold]
               :syntax-quote-paren [:green],
               :uneval :magenta,
               :user-fn [:white]}})

(defn println! [out ^String msg]
  (cond
    (instance? OutputStream out)
    (do (OutputStream/.write out (String/.getBytes msg))
        (OutputStream/.write out (String/.getBytes "\n")))

    (instance? Writer out)
    (do (Writer/.write out msg)
        (Writer/.write out "\n"))))

(defn echo [out data]
  (if (instance? Throwable data)
    (binding [pretty.exceptions/*print-level* 100]
      (println! out (pretty.exceptions/format-exception data)))
    (let [pretty-string (zprint/czprint-str data opts)]
      (println! out pretty-string))))
