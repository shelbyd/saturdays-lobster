pub fn handle_query(read: &str) -> String {
    read
        .graphemes(true)
        .rev()
        .flat_map(|g| g.chars())
        .collect()
}
