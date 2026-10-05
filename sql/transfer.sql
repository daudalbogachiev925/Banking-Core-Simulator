BEGIN;
WITH src AS (
    UPDATE accounts SET balance = balance - $amount
    WHERE id = $from AND balance >= $amount
    RETURNING id
)
INSERT INTO transactions (from_acc, to_acc, amount, status)
SELECT $from, $to, $amount, 'done'
WHERE EXISTS (SELECT 1 FROM src);

UPDATE accounts SET balance = balance + $amount WHERE id = $to;

INSERT INTO audit_log (action, details)
VALUES ('transfer', json_build_object('from',$from,'to',$to,'amount',$amount));

COMMIT;
