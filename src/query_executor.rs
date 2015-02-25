use query::Query;

extern crate core;
use self::core::error::Error;

pub fn handle_query(read: &str) -> String {
    match read.parse::<Query>() {
        Ok(query) => query.execute(),
        Err(err) => format!("{}", err),
    }
}
