module Day07
  extend self

  def run(input_file : String)
    pwd = [] of String
    dir_size = Hash(String, Int32).new(default_value: 0)

    File.read(input_file).lines.each { |line|
      case line
      when "$ cd /"      then pwd = [] of String
      when "$ cd .."     then pwd.pop
      when /^\$ cd \w+$/ then pwd.push(new_dir = line[4..])
      when /^\d+ [\w.]+$/
        file_size = line.split[0].to_i
        # Build absolute paths for all directories along the pwd and add the file size to them
        pwd.accumulate("/") { |acc, dir| acc + "/" + dir }.each { |dir|
          dir_size[dir] += file_size
        }
      end
    }

    p1 = dir_size.values.select { |size| size <= 100000 }.sum

    cur_free_space = 70000000 - dir_size["/"]
    need_to_delete = 30000000 - cur_free_space
    p2 = dir_size.values.select { |size| size >= need_to_delete }.min

    return p1, p2
  end
end
