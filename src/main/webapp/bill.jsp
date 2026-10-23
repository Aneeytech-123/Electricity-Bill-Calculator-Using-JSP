<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/billing.jspf" %>
<%
    request.setCharacterEncoding("UTF-8");

    String name      = trimmed(request.getParameter("name"));
    String consumer  = trimmed(request.getParameter("consumer"));
    String unitsText = trimmed(request.getParameter("units"));

    // Opened directly without submitting the form
    if (request.getParameter("units") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    String error = validate(name, consumer, unitsText);
    if (error != null) {
        response.sendRedirect("index.jsp?error=" + error
                + "&name=" + encode(name)
                + "&consumer=" + encode(consumer)
                + "&units=" + encode(unitsText));
        return;
    }

    int units = Integer.parseInt(unitsText);
    double totalBill = calculateBill(units);
    int[] slabUnits = unitsPerSlab(units);

    int currentStep = 2;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bill Details | Electricity Bill Calculator</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<main class="page">
    <%@ include file="/WEB-INF/jspf/steps.jspf" %>

    <section class="card">
        <div class="hero-icon" aria-hidden="true">
            <svg viewBox="0 0 48 48">
                <path class="stroke" d="M12 6h18l6 6v14" />
                <path class="stroke" d="M12 6v34h16" />
                <path class="stroke" d="M18 15h3M24 15h6M18 21h3M24 21h6M18 27h3M24 27h4" />
                <circle class="fill" cx="35" cy="35" r="8" />
                <path class="rupee" d="M31.5 30.5h7M31.5 33.3h7M33 30.5c3.4 0 3.4 5.6 0 5.6h-1.3l4.6 4.6" />
            </svg>
        </div>

        <h1 class="title"><span class="grad">Bill Details</span></h1>
        <p class="subtitle">Here is your electricity consumption summary</p>

        <div class="info-grid">
            <div class="info">
                <svg viewBox="0 0 24 24" aria-hidden="true">
                    <circle cx="12" cy="8" r="4" /><path d="M4.5 21c.6-4 3.6-6.3 7.5-6.3s6.9 2.3 7.5 6.3" />
                </svg>
                <span class="info-label">Customer</span>
                <span class="info-value"><%= esc(name) %></span>
            </div>
            <div class="info">
                <svg viewBox="0 0 24 24" aria-hidden="true">
                    <rect x="2.5" y="5" width="19" height="14" rx="2" />
                    <circle cx="8" cy="11" r="2" /><path d="M5 16c.6-1.8 1.7-2.6 3-2.6s2.4.8 3 2.6M14 10h4.5M14 13.5h4.5" />
                </svg>
                <span class="info-label">Consumer Number</span>
                <span class="info-value"><%= esc(consumer) %></span>
            </div>
            <div class="info">
                <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M13.5 2L5 13.5h6L9.5 22 19 9.5h-6z" /></svg>
                <span class="info-label">Units Consumed</span>
                <span class="info-value"><%= units %> Units</span>
            </div>
        </div>

        <h2 class="section-title">Slab-wise Calculation</h2>
        <div class="slabs">
<%
    boolean anySlab = false;
    for (int i = 0; i < slabUnits.length; i++) {
        if (slabUnits[i] == 0) continue;
        anySlab = true;
        double slabAmount = slabUnits[i] * SLAB_RATES[i];
%>
            <div class="slab">
                <div>
                    <span class="slab-name"><%= SLAB_NAMES[i] %></span>
                    <span class="slab-rate"><%= slabUnits[i] %> units @ Rs. <%= money(SLAB_RATES[i]) %> / unit</span>
                </div>
                <span class="slab-amount">Rs. <%= money(slabAmount) %></span>
            </div>
<%
    }
    if (!anySlab) {
%>
            <div class="slab">
                <div>
                    <span class="slab-name">No units consumed</span>
                    <span class="slab-rate">0 units this billing period</span>
                </div>
                <span class="slab-amount">Rs. 0.00</span>
            </div>
<%
    }
%>
        </div>

        <div class="total">
            <div>
                <span class="total-label">Total Electricity Bill</span>
                <span class="total-sub">(Amount Payable)</span>
            </div>
            <span class="total-amount">Rs. <%= money(totalBill) %></span>
        </div>

        <form action="success.jsp" method="post">
            <input type="hidden" name="name" value="<%= esc(name) %>">
            <input type="hidden" name="consumer" value="<%= esc(consumer) %>">
            <input type="hidden" name="units" value="<%= units %>">
            <button type="submit" class="btn">
                Continue
                <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M4 12h15M13 6l6 6-6 6" /></svg>
            </button>
        </form>
    </section>

    <a class="back-link" href="index.jsp?name=<%= esc(encode(name)) %>&amp;consumer=<%= esc(encode(consumer)) %>&amp;units=<%= units %>">
        <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M20 12H5M11 6l-6 6 6 6" /></svg>
        Back to Details
    </a>
</main>
</body>
</html>
