require './roman.rb'

# write data aka matrix
def wd
  $f.write("$\\begin{Bmatrix}\n")
  $d.each_with_index { |n,ri| n.each_with_index { |m,ci| $f.write("#{m.round(2)}" + ((ci != (n.length() - 1))? " & " : " \\\\\n")) } }
  $f.write("\\end{Bmatrix}$\n")
end

# make a equal sign with text below it
def eq t
  $f.write("$\\underset{\\mathrm{#{t}}}{\\Longrightarrow}$")
end

# diving a whole row with a value we want to calulate
def div n, t
  $d[n].map! { |n| n /= t}
end

# substratcion of the line <i> of multiplying the base line <n> with the value we are trying to calulate<x>
def submul n, i, x
  $d[i].map!
        .with_index { |e,i| e -= x * $d[n][i]}
end



# write div calculation to latex
def pdiv n, t
  wd
  div n, t
  eq "#{(n+1).roman}/#{t.round(2)}"
  wd
  $f.write "\\\\\n\\\\\n"
end

# write submul calculation to latex
def psubmul n, li, x
  wd
  submul n, li, x
  eq "#{(li+1).roman}-#{(n+1).roman}*#{x.round(2)}"
  wd
  $f.write "\\\\\n\\\\\n"
end

if ARGV.index('-h')
  puts <<~EOT
gauss [flags] [parameters] input
flags:
\t-l <filename>\t: Latex output to filename
\t-d\t\t: Print over every iteration
EOT
  return
end

if ARGV.length == 0
  puts "No input file said"
  exit 1
end

$d = File.open(ARGV[-1],'r')
         .map(&:chomp)
         .map{ |l| l.split('=')
                    .map{ |n| n.split('+') }
                    .flatten
                    .map{ |n| (n.chars & ['-'] == ['-'])?(a = n.split('-'); [a[0], a[1..].map{|m| '-' + m }] ):n}
                    .flatten
                    .map{ |s| (s.count("a-zA-Z") > 0)?s[..s.index(/[a-zA-Z]/)-1]: s }
                    .map(&:to_f) }

if ARGV.index('-l')
  fn = ARGV[ARGV.index('-l')+1]
  if ARGV.length < 3 || fn[0] == '-'
    puts "No latex output file"
    exit 1
  end
  $f = File.open(fn, 'w')

  # latex head
  $f.write(<<~EOT
\\documentclass[11pt]{article}
\\usepackage[a4paper, total={6.4in, 10in}]{geometry}
\\usepackage{amsmath}
\\usepackage{parskip}
\\linespread{1.5}
\\begin{document}
EOT
          )
  lc = $d.length-1
  [*0..lc].each do |n|
    pdiv n, $d[n][n]

    $d.each{ |n| p n } if ARGV.index('-d')
    
    $d.each_with_index do |l, i|
      next if l == $d[n]
      psubmul n, i, $d[i][n]
      $d.each{ |n| p n } if ARGV.index('-d')
    end
  end

  $f.write("\\end{document}")
  $f.close

  Kernel.fork { _ =  `pdflatex #{ARGV[ARGV.index('-l')+1]}` }
else
  lc = $d.length-1
  [*0..lc].each do |n|
    div n, $d[n][n]
    
    $d.each{ |n| p n } if ARGV.index('-d')
    
    $d.each_with_index do |l, i|
      next if l == $d[n]
      submul n, i, $d[i][n]
      $d.each{ |n| p n } if ARGV.index('-d')
    end
  end
end
 
$d.each{ |n| p n }
