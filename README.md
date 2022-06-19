[![CI status](https://github.com/latamgateway/bs2_api/actions/workflows/test.yml/badge.svg?branch=main)](https://github.com/latamgateway/bs2_api/actions/workflows/test.yml)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/tag/latamgateway/bs2_api.svg?style=flat-square)](http://github.com/latamgateway/bs2_api/releases)
[![Version](https://img.shields.io/gem/v/bs2_api.svg?style=flat-square)](https://rubygems.org/gems/bs2_api)
[![GitHub](https://img.shields.io/github/license/latamgateway/bs2_api?style=flat-square)](https://github.com/latamgateway/bs2_api/blob/main/LICENSE)

# Bs2Api

Integração com a API do Banco BS2: https://devs.bs2.com/manual/pix-clientes

TO-DO:
- Pagamentos (**Transfere** dinheiro para alguém)
  - [x] Criar pagamento por Chave
  - [x] Criar pagamento Manual
  - [x] Confirmar pagamento
  - [x] Consultar pagamento
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

pay_key.payment.payment_id
=> "96f0b3c4-4c76-4a7a-9933-9c9f86df7490" # pagamentoId gerado no BS2

pay_key.payment.end_to_end_id
=> "E710278662021061618144401750781P" # endToEndId gerado no BS2

pay_key.payment.class
=> Bs2Api::Entities::Payment
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

pay_manual.payment.payment_id
=> "96f0b3c4-4c76-4a7a-9933-9c9f86df7490" # Payment id no BS2

pay_manual.payment.end_to_end_id
=> "E710278662021061618144401750781P" # endToEndId gerado no BS2

pay_manual.payment.class
=> Bs2Api::Entities::Payment
```

### Confirmar ordem de transferência
Após criar um Payment é necessário confirmar, nessa etapa o dinheiro é de fato transferido.
Nessa etapa é necessário **informar o valor** que deseja ser transferido.

```ruby

# Ambos modelos de criação da ordem de pagamento possuem o mesmo objeto payment
# podendo ser utilizado da mesma forma nos dois casos:
# pay_key.payment ou pay_manual.payment

payment = pay_key.payment
amount = 10.50

confirmation = Bs2Api::Payment::Confirmation.new(payment, value: amount).call

# Caso a confirmação dê problema, um erro será lançado.
raise Bs2Api::Errors::ConfirmationError

# Caso nenhum erro seja lançado significa que foi sucesso. Você pode ter certeza com
confirmation.success?
```

### Busca informações do pagamento
```ruby
payment_id = "96f0b3c4-4c76-4a7a-9933-9c9f86df7490"

payment = Bs2Api::Payment::Detail.new(payment_id).call # Payment id no BS2
payment.id 
=> "96f0b3c4-4c76-4a7a-9933-9c9f86df7490"

payment.end_to_end_id
=> "E710278662021061618144401750781P" # endToEndId gerado no BS2

payment.class
=> Bs2Api::Entities::Payment
```


### Async API
Add initial asyc BS2 API implementation.
    
The API allows to pass multiple request all at once. In order to do so you must:
1. Create `Bs2Api::Payment::Async`
2. Create one or more PIX keys
3. For each PIX key create `Bs2Api::Entities::AsyncRequest` passing in the PIX key, internal identifier and the value of the transaction
4. Add each async request to the async payment via `Bs2Api::Payment::Async#add_request`
5. When all requests are added call `Bs2Api::Payment::Async#call`
6. In the response you will get list of payments of type `Bs2Api::Entities::AsyncResponse` whose confirmation will be sent via webhook
6.1 If even one of the requests has invalid data, the response will be 400 and we won't get anything via webhook
7. If the response from 6 was 202 but we don't get a webhook notification we should start polling the response manually. This is done by calling `Bs2Api::Payment::Async::check_payment_status`. It has one parameter the `Bs2Api::Entities::AsyncResponse#request_id`.The result from this will be `Bs2Api::Entities::AsyncStatus`, using it you can check if the payment was rejected or confirmed.

```ruby
 pix_key = Bs2Api::Entities::PixKey.new(
  key: 'joao@gmail.com',
  type: 'EMAIL'
)

async_request = Bs2Api::Entities::AsyncRequest.new(
  pix_key: pix_key,
  value: 10.0,
  identificator: 'payment1'
)

async_payment = Bs2Api::Payment::Async.new
async_payment.add_request(async_request)

response_list = async_payment.call

# Wait for webhook if notification does not arrive (for example for the first item)
response_status = Bs2Api::Payment::Async.check_payment_status(response_list[0].request_id)

# Check the status
if response_status.rejected?
  puts response_status.rejection_description
end
```

### Classes de erros:
```ruby
# Todos erros herdam de:
Bs2Api::Errors::Base

# Errors possíveis de serem lançados
Bs2Api::Errors::BadRequest
Bs2Api::Errors::ConfirmationError
Bs2Api::Errors::InvalidCustomer
Bs2Api::Errors::InvalidPixKey
Bs2Api::Errors::MissingConfiguration
Bs2Api::Errors::ServerError
Bs2Api::Errors::Unauthorized
```

---

### Observações
- Método `call` retorna o próprio objeto
- Em caso de retorno diferente de sucesso na comunicação com a API do Bs2, um erro sempre será lançado.
