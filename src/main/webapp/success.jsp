<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/billing.jspf" %>
<%
    request.setCharacterEncoding("UTF-8");

    String name      = trimmed(request.getParameter("name"));
    String consumer  = trimmed(request.getParameter("consumer"));
    String unitsText = trimmed(request.getParameter("units"));

    // The bill is recalculated on the server rather than trusted from the browser
    if (validate(name, consumer, unitsText) != null) {
        response.sendRedirect("index.jsp");
        return;
    }

    int units = Integer.parseInt(unitsText);
    double totalBill = calculateBill(units);

    int currentStep = 3;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment Successful | Electricity Bill Calculator</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<main class="page">
    <%@ include file="/WEB-INF/jspf/steps.jspf" %>

    <section class="card">
        <div class="celebrate" aria-hidden="true">
            <span class="confetti c1"></span><span class="confetti c2"></span><span class="confetti c3"></span>
            <span class="confetti c4"></span><span class="confetti c5"></span><span class="confetti c6"></span>
            <span class="confetti c7"></span><span class="confetti c8"></span><span class="confetti c9"></span>
            <span class="confetti c10"></span><span class="confetti c11"></span><span class="confetti c12"></span>
            <span class="confetti c13"></span><span class="confetti c14"></span><span class="confetti c15"></span>
            <span class="confetti c16"></span><span class="confetti c17"></span><span class="confetti c18"></span>
            <span class="check-big">
                <svg viewBox="0 0 24 24"><path d="M5 12.5l4.5 4.5L19 7.5" /></svg>
            </span>
            <span class="popper">🎉</span>
        </div>

        <h1 class="title"><span class="grad">Bill Payment Successful!</span></h1>
        <p class="subtitle">Your electricity bill has been calculated successfully.</p>
        <p class="thanks">Thank you! <span aria-hidden="true">😊</span></p>

        <dl class="summary">
            <div class="summary-row"><dt>Customer Name</dt><dd><%= esc(name) %></dd></div>
            <div class="summary-row"><dt>Consumer Number</dt><dd><%= esc(consumer) %></dd></div>
            <div class="summary-row"><dt>Units Consumed</dt><dd><%= units %> Units</dd></div>
            <div class="summary-row"><dt>Total Electricity Bill</dt><dd class="amount">Rs. <%= money(totalBill) %></dd></div>
        </dl>

        <div class="status">
            <span class="status-icon" aria-hidden="true">
                <svg viewBox="0 0 24 24"><path d="M5 12.5l4.5 4.5L19 7.5" /></svg>
            </span>
            <div>
                <span class="status-label">Payment Status</span>
                <span class="status-value">Completed Successfully</span>
            </div>
        </div>

        <a class="btn" href="index.jsp">
            <svg class="home" viewBox="0 0 24 24" aria-hidden="true"><path d="M12 3L2.5 11.5H5.5V21h5v-6h3v6h5v-9.5h3z" /></svg>
            Go to Home
        </a>
    </section>

    <p class="footer-note"><span aria-hidden="true">🎉</span> Thank you for using our service! <span aria-hidden="true">🎉</span></p>
    <p class="footer-sub">Stay powered, stay happy! <span aria-hidden="true">⚡</span></p>
</main>
</body>
</html>
