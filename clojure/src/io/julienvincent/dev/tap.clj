(ns io.julienvincent.dev.tap
  (:require
   [clj-commons.format.exceptions :as pretty.exceptions]
   [puget.printer :as puget]))

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

(defn add-stdout-tap []
  (add-tap
   (fn [data]
     (if (instance? Throwable data)
       (binding [pretty.exceptions/*print-level* 100]
         (.println System/out (pretty.exceptions/format-exception data)))
       (let [pretty-string (puget/pprint-str data puget-opts)]
         (.println System/out pretty-string))))))
