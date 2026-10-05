CREATE OR REPLACE PROCEDURE sp_accrue_interest(p_rate NUMERIC)
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE accounts
    SET balance = balance + balance * p_rate / 100
    WHERE type = 'deposit';
    INSERT INTO audit_log (action, details)
    VALUES ('interest_accrual', json_build_object('rate', p_rate));
END; $$;
