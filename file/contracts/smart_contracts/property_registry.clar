;; PropVerify Property Registry Smart Contract

;; Define data vars and maps
(define-data-var total-properties uint u0)
(define-map properties uint {owner: principal, status: (string-ascii 20), price: uint, description: (string-utf8 256)})

;; Error codes
(define-constant err-not-owner (err u100))
(define-constant err-already-listed (err u101))
(define-constant err-not-listed (err u102))

;; Define public functions
(define-public (register-property (property-id uint) (description (string-utf8 256)))
  (begin
    (map-set properties property-id {owner: tx-sender, status: "registered", price: u0, description: description})
    (var-set total-properties (+ (var-get total-properties) u1))
    (ok true)))

(define-public (list-property (property-id uint) (price uint))
  (let ((property (unwrap! (map-get? properties property-id) (err u404))))
    (asserts! (is-eq (get owner property) tx-sender) err-not-owner)
    (asserts! (is-eq (get status property) "registered") err-already-listed)
    (ok (map-set properties property-id 
                 (merge property {status: "listed", price: price})))))

(define-public (unlist-property (property-id uint))
  (let ((property (unwrap! (map-get? properties property-id) (err u404))))
    (asserts! (is-eq (get owner property) tx-sender) err-not-owner)
    (asserts! (is-eq (get status property) "listed") err-not-listed)
    (ok (map-set properties property-id 
                 (merge property {status: "registered", price: u0})))))

(define-public (buy-property (property-id uint))
  (let ((property (unwrap! (map-get? properties property-id) (err u404))))
    (asserts! (is-eq (get status property) "listed") err-not-listed)
    (let ((price (get price property))
          (seller (get owner property)))
      (try! (stx-transfer? price tx-sender seller))
      (ok (map-set properties property-id 
                   (merge property {owner: tx-sender, status: "registered", price: u0}))))))

;; Define read-only functions
(define-read-only (get-property (property-id uint))
  (map-get? properties property-id))

(define-read-only (get-total-properties)
  (var-get total-properties))