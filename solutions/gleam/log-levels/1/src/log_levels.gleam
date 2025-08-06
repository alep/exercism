import gleam/string


pub fn message(log_line: String) -> String {
  let  log_line = case log_line {
    "[ERROR]: " <> rest -> rest
    "[WARNING]: " <> rest -> rest
    "[INFO]: " <> rest -> rest    
    _ -> log_line
  }
  log_line |> string.trim
}

pub fn log_level(log_line: String) -> String {
    let  log_level = case log_line {
    "[ERROR]: " <> _rest -> "error"
    "[WARNING]: " <> _rest -> "warning"
    "[INFO]: " <> _rest -> "info"
    _ -> ""
  }
  log_level |> string.trim
}

pub fn reformat(log_line: String) -> String {
  let #(level, message) = #(log_level(log_line), message(log_line))
  message <> " (" <> level <> ")"
}
