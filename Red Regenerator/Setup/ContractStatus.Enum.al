namespace Red.Regenerator;
enum 11311117 "Red Reg Contract Status"
{
    Extensible = true;

    value(0; Concept) { Caption = 'Concept'; }
    value(1; Accepted) { Caption = 'Accepted'; }
    value(2; Active) { Caption = 'Active'; }
    value(3; Expired) { Caption = 'Expired'; }
    value(4; Closed) { Caption = 'Closed'; }
    value(5; Canceled) { Caption = 'Canceled'; }
}

// Contract flow:
// 1. Create contract, status concept
// 2. Send contracrt to customer
// 3. Approval generates order/invoice
// 4. Shipping the order/invoice activates the contract
// 5. Contract expires after duration three choices
// 6. Return to concept or approved, close or cancel