;; PropVerify Property Registry Smart Contract

;; Define data vars and maps
(define-data-var total-properties uint u0)
(define-map properties uint {owner: principal, status: (string-ascii 20)})

;; Define public functions
(define-public (register-property (property-id uint))
  (begin
    (map-set properties property-id {owner: tx-sender, status: "registered"})
    (var-set total-properties (+ (var-get total-properties) u1))
    (ok true)))

;; Define read-only functions
(define-read-only (get-property-owner (property-id uint))
  (get owner (map-get? properties property-id)))