((string_content) @injection.content
  (#match? @injection.content "^(SET|TRUNCATE|SELECT|CREATE|DELETE|ALTER|UPDATE|DROP|INSERT|WITH)")
  (#escape! @injection.content "\"")
  (#set! injection.language "sql"))
