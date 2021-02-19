Gem::Specification.new do |s|
  s.name        = "swaggery"
  s.version     = "0.1.0"
  s.summary     = "SWAGGERY"
  s.description = "SWAGGERY"
  s.homepage    = "https://github.com/sosedoff/swaggery"
  s.authors     = ["Dan Sosedoff"]
  s.email       = ["dan.sosedoff@gmail.com"]
  s.license     = "MIT"

  s.add_dependency "json", "~> 2.5"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{|f| File.basename(f)}
  s.require_paths = ["lib"]
end