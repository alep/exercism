import gleam/string
import gleam/list
import gleam/result
import simplifile

fn is_not_empty(s: String) -> Bool {
  ! string.is_empty(s)
}

pub fn read_emails(path: String) -> Result(List(String), Nil) {
    case simplifile.read(path) {
        Ok(content) -> Ok(content |> string.split("\n") |> list.filter(is_not_empty))
        Error(_) -> Error(Nil)
    }
}

pub fn create_log_file(path: String) -> Result(Nil, Nil) {
  case simplifile.create_file(path) {
      Error(_) -> Error(Nil)
      Ok(_) -> Ok(Nil)
  }
}

pub fn log_sent_email(path: String, email: String) -> Result(Nil, Nil) {
    case simplifile.append(path, string.trim(email) <> "\n") {
      Ok(_) -> Ok(Nil)
      Error(_) -> Error(Nil)
    }
}

pub fn send_newsletter(
  emails_path: String,
  log_path: String,
  send_email: fn(String) -> Result(Nil, Nil),
) -> Result(Nil, Nil) {
  create_log_file(log_path)
  case read_emails(emails_path) {
    Ok(emails) -> {
       emails |> list.map(
        fn(email: String) -> Result(Nil, Nil) {
          case send_email(email) {
            Ok(_) -> log_sent_email(log_path, email)
            err -> err
        }
      })      
    }
    Error(_) -> [Error(Nil)] 
  } |> list.fold(Ok(Nil), result.or)
}