use query::Query;

pub fn handle_query(read: &str) -> String {
    match read.parse::<Query>() {
        Ok(query) => query.execute(),
        Err(err) => String::from_str(""),
    }
}
