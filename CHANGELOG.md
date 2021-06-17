## [1.0.0] - 2021-06-18
- Changed payment.id to payment.payment_id
- Changed payment.merchant_id to payment.end_to_end_id

## [0.4.0] - 2021-06-17
- Configuration#valid? missing return true
- Created Util::Response.parse_error
- Bs2Api::Payment::Confirmation#success? was private, moved it to public

## [0.3.1] - 2021-06-16
- Method Hash#to_query conflicting with Rails

## [0.3.0] - 2021-06-16
- Confirmation, Adjust README.md

## [0.2.0] - 2021-06-15
- Entities, Auth, Create Pix Key Payment

## [0.1.0] - 2021-06-11
- Initial release
