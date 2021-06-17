[![CI status](https://github.com/latamgateway/bs2_api/actions/workflows/test.yml/badge.svg?branch=main)](https://github.com/latamgateway/bs2_api/actions/workflows/test.yml)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/tag/latamgateway/bs2_api.svg?style=flat-square)](http://github.com/latamgateway/bs2_api/releases)
[![Version](https://img.shields.io/gem/v/bs2_api.svg?style=flat-square)](https://rubygems.org/gems/bs2_api)

# Bs2Api

Integração com a API do Banco BS2: https://devs.bs2.com/manual/pix-clientes

TO-DO:
- Pagamentos (**Transfere** dinheiro para alguém)
  - [x] Criar pagamento por Chave
  - [x] Criar pagamento Manual
  - [x] Confirmar pagamento
  - [ ] Consultar pagamento
- Recebimentos (**Recebe** dinheiro de alguém)
  - [ ] Cobrança estático
  - [ ] Cobrança dinâmico
  - [ ] Consultar cobrança


## Instalação

Adicionar no seu Gemfile:
```ruby
gem 'bs2_api'
```

E então execute:
```bash
bundle install
```

Ou instale diretamente via:
```bash
gem install bs2_api
```

### Configuração
Via variável de ambiente:
```bash
BS2_CLIENT_ID
BS2_CLIENT_SECRET
BS2_CLIENT_ENVIRONMENT # production or sandbox. Default to sandbox
```

ou via initializer:

```ruby
Bs2Api.configure do |config|
  config.client_id     = 'you_bs2_client_id'
  config.client_secret = 'you_bs2_client_secret'
  config.env           = 'sandbox' # ou production
end
```

### Inicia ordem de Transferência PIX via: Chave

```ruby
pix_key = Bs2Api::Entities::PixKey.new(
  key: 'joao@gmail.com',
  type: 'EMAIL'
)

# Caso ocorra algum problema na criação, um erro será lançado
# Veja abaixo (Classes de errors) quais erros que podem ser lançados
pay_key = Bs2Api::Payment::Key.new(pix_key).call

pay_key.payment.id
=> "96f0b3c4-4c76-4a7a-9933-9c9f86df7490" # pagamentoId gerado no BS2

pay_key.payment.merchantId
=> "E710278662021061618144401750781P" # endToEndId gerado no BS2

```

### Inicia ordem de Transferência PIX via: Manual

```ruby
account = Bs2Api::Entities::Account.new(
  bank_code: "218",
  agency: "0993",
  number: "042312",
  type: "ContaCorrente" # ContaCorrente, ContaSalario ou Poupanca
)

customer = Bs2Api::Entities::Customer.new(
  document: "88899988811",
  type: "CPF",
  name: "Rick Sanches",
  business_name: "Nome fantasia" # Utilizar apenas se for type CNPJ
)

receiver_bank = Bs2Api::Entities::Bank.new(
  account: account,
  customer: customer
)

pay_manual = Bs2Api::Payment::Manual.new(receiver_bank).call

pay_manual.payment.id
=> "96f0b3c4-4c76-4a7a-9933-9c9f86df7490" # UUID gerado no BS2

pay_manual.payment.merchantId
=> "E710278662021061618144401750781P" # endToEndId gerado no BS2
```

### Confirmar ordem de transferência
```ruby
# Após criar um Payment é necessário confirmar
# Nessa etapa o dinheiro é de fato transferido

# Tanto a ordem de transferência via chave ou manual tem o mesmo payment.
# Caso tenha criado via chave no passo anterior:
payment = pay_key.payment

# Ou caso tenha criado a ordem via Manual no passo anterior:
payment = pay_manual.payment

amount = 10.50
confirmation = Bs2Api::Payment::Confirmation.new(payment, value: amount).call

# Caso a confirmação de problema, um erro será lançado.
raise Bs2Api::Errors::ConfirmationError

# Caso nenhum erro seja lançado (já é sucesso) porém, você pode ter certeza com
confirmation.success?
```
---
### Classes de erros:
```ruby
# Todos erros herdam de:
Bs2Api::Errors::Base

Bs2Api::Errors::BadRequest
Bs2Api::Errors::ConfirmationError
Bs2Api::Errors::InvalidCustomer
Bs2Api::Errors::InvalidPixKey
Bs2Api::Errors::MissingConfiguration
Bs2Api::Errors::ServerError
Bs2Api::Errors::Unauthorized

# Caso não queira tratar um erro em específico basta fazer rescue do Base
rescue Bs2Api::Errors::Base => e
  puts "Erro: #{e.message}"
end
```
