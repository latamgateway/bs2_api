# Bs2Api

Integração com a API do Banco BS2: https://devs.bs2.com/manual/pix-clientes

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
  config.client_id       = 'you_bs2_client_id'
  config.client_secret   = 'you_bs2_client_secret'
  config.pix_environment = 'pix_enviroment'
end
```

### Iniciar pagamento por Chave

```ruby
pix_key = Bs2Api::Entities::PixKey.new(
  key: 'joao@gmail.com',
  type: 'EMAIL'
)

payment = Bs2Api::Payment::Key.new(pix_key).call
```

Tipos:
```bash
CPF
CNPJ
PHONE
EMAIL
EVP (Chave aleatória)
```


### Iniciar pagamento Manual

```ruby
account = Bs2Api::Entities::Account.new(
  bank_code: '341',
  bank_name: 'Itaú',
  agency: '0944',
  number: '09442-1',
  type: 'ContaCorrente'
)

customer = Bs2Api::Entities::Customer.new(
  document: '88899988811',
  type: 'CPF',
  name: 'João Silva'
)

receiver = Bs2Api::Entities::Bank.new(
  account: account, 
  customer: customer
)

payment = Bs2Api::Payment::Manual.new(receiver).call
```

### Objetos

##### Payment
```ruby
payment.id # pagamentoId
payment.merchant_id # endToEndId
payment.receiver # recebedor
payment.payer # pagador

payment.receiver.class
=> Bs2Api::Entities::Bank

payment.payer.class
=> Bs2Api::Entities::Bank

payment.payer.account # conta
=> Bs2Api::Entities::Account

payment.payer.customer # pessoa
=> Bs2Api::Entities::Customer

payment.to_hash
{
  "pagamentoId"=>"123", 
  "endToEndId"=>"456", 
  "recebedor"=>{
    "ispb"=>"71027866", 
    "conta"=>{
      "banco"=>"218", 
      "bancoNome"=>"BCO BS2 S.A.", 
      "agencia"=>"0001", 
      "numero"=>"3134806", 
      "tipo"=>"ContaCorrente"
    },
    "pessoa"=>{
      "documento"=>"25215188000116", 
      "tipoDocumento"=>"CNPJ", 
      "nome"=>"Teste Automatizado", 
      "nomeFantasia"=>nil
    }
  }, 
  "pagador"=>{
    "ispb"=>"71027866", 
    "conta"=>{
      "banco"=>"218", 
      "bancoNome"=>"BCO BS2 S.A.", 
      "agencia"=>"0001", 
      "numero"=>"3134806", 
      "tipo"=>"ContaCorrente"
    },
    "pessoa"=>{
      "documento"=>"25215188000116", 
      "tipoDocumento"=>"CNPJ", 
      "nome"=>"Teste Automatizado", 
      "nomeFantasia"=>nil
    }
  }
}
```