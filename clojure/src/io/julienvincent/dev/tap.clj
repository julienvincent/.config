(ns io.julienvincent.dev.tap
  (:require
   [clj-commons.format.exceptions :as pretty.exceptions]
   [zprint.core :as zprint]))

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
               :user-fn [:white]}}),

(defn add-stdout-tap []
  (add-tap
   (fn [data]
     (if (instance? Throwable data)
       (binding [pretty.exceptions/*print-level* 100]
         (.println System/out (pretty.exceptions/format-exception data)))
       (let [pretty-string (zprint/czprint-str data opts)]
         (.println System/out pretty-string))))))
