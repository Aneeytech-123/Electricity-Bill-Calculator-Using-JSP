<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/billing.jspf" %>
<%
    // Values sent back from bill.jsp when validation fails, so the form keeps them
    String error    = trimmed(request.getParameter("error"));
    String name     = trimmed(request.getParameter("name"));
    String consumer = trimmed(request.getParameter("consumer"));
    String units    = trimmed(request.getParameter("units"));

    String errorMessage = null;
    if (error.equals("name"))          errorMessage = "Please enter the customer name (up to 60 characters).";
    else if (error.equals("consumer")) errorMessage = "Consumer number must contain 5 to 15 digits.";
    else if (error.equals("units"))    errorMessage = "Units consumed must be a whole number from 0 to " + MAX_UNITS + ".";

    int currentStep = 1;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Electricity Bill Calculator</title>
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
                <path class="bolt" d="M36 29.5l-4.2 6.3h3.2l-1 5.7 4.4-6.6h-3.2z" />
            </svg>
        </div>

        <h1 class="title">
            <span class="grad">Electricity Bill</span>
            <span class="title-sub">Calculator</span>
        </h1>
        <p class="subtitle">Calculate your electricity bill quickly and easily</p>

<%  if (errorMessage != null) { %>
        <div class="alert" role="alert"><%= esc(errorMessage) %></div>
<%  } %>

        <form class="form" action="bill.jsp" method="post" autocomplete="off">
            <label class="field">
                <span class="field-label">Customer Name</span>
                <span class="input-wrap">
                    <input type="text" name="name" value="<%= esc(name) %>" placeholder="Enter customer name"
                           maxlength="60" required>
                    <svg class="input-icon" viewBox="0 0 24 24" aria-hidden="true">
                        <circle cx="12" cy="8" r="4" /><path d="M4 21c0-4.4 3.6-7 8-7s8 2.6 8 7z" />
                    </svg>
                </span>
            </label>

            <label class="field">
                <span class="field-label">Consumer Number</span>
                <span class="input-wrap">
                    <input type="text" name="consumer" value="<%= esc(consumer) %>" placeholder="Enter consumer number"
                           inputmode="numeric" pattern="\d{5,15}" maxlength="15" required
                           title="5 to 15 digits">
                    <svg class="input-icon outline" viewBox="0 0 24 24" aria-hidden="true">
                        <rect x="2.5" y="5" width="19" height="14" rx="2" />
                        <circle cx="8" cy="11" r="2" /><path d="M5 16c.6-1.8 1.7-2.6 3-2.6s2.4.8 3 2.6M14 10h4.5M14 13.5h4.5" />
                    </svg>
                </span>
            </label>

            <label class="field">
                <span class="field-label">Units Consumed</span>
                <span class="input-wrap">
                    <input type="number" name="units" value="<%= esc(units) %>" placeholder="Enter units (kWh)"
                           min="0" max="<%= MAX_UNITS %>" step="1" required>
                    <svg class="input-icon" viewBox="0 0 24 24" aria-hidden="true">
                        <path d="M13.5 2L5 13.5h6L9.5 22 19 9.5h-6z" />
                    </svg>
                </span>
            </label>

            <button type="submit" class="btn">
                Calculate Bill
                <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M4 12h15M13 6l6 6-6 6" /></svg>
            </button>
        </form>
    </section>

    <p class="tagline"><span class="bolt-emoji" aria-hidden="true">⚡</span> Simple <i>•</i> Fast <i>•</i> Accurate</p>
</main>
</body>
</html>
