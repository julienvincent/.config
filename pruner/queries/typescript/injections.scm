((template_string
  (string_fragment) @injection.content
    (#match? @injection.content "^(SET|TRUNCATE|SELECT|CREATE|DELETE|ALTER|UPDATE|DROP|INSERT|WITH)")
    (#set! injection.language "sql")))
