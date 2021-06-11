# frozen_string_literal: true

require_relative "lib/bs2_api/version"

Gem::Specification.new do |spec|
  spec.name          = "bs2_api"
  spec.version       = Bs2Api::VERSION
  spec.authors       = ["Kim Pastro"]
  spec.email         = ["kimpastro@gmail.com"]

  spec.summary       = "Integração com a API do BS2"
  spec.description   = "Criar pagamentos PIX"
  spec.homepage      = "https://github.com/kimpastro/bs2_api"
  spec.required_ruby_version = ">= 2.7.2"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/kimpastro/bs2_api"
  spec.metadata["changelog_uri"] = "https://github.com/kimpastro/bs2_api/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rspec", "~> 3.10"
  spec.add_dependency "http", "~> 4.4"
end