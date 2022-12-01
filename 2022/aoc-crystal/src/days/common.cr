# Parse the input file as a list of ints
def parse_int_list(file_path : String) : Array(Int64)
  File.read_lines(file_path).map(&.to_i64)
end
