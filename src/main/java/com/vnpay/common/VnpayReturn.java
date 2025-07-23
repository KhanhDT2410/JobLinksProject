package com.vnpay.common;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

/**
 * Servlet to handle VNPAY return URL and forward transaction result to paymentResult.jsp
 */
public class VnpayReturn extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            // Collect all request parameters
            Map<String, String> fields = new HashMap<>();
            for (Enumeration<String> params = request.getParameterNames(); params.hasMoreElements();) {
                String fieldName = URLEncoder.encode(params.nextElement(), StandardCharsets.US_ASCII.toString());
                String fieldValue = URLEncoder.encode(request.getParameter(fieldName), StandardCharsets.US_ASCII.toString());
                if ((fieldValue != null) && (fieldValue.length() > 0)) {
                    fields.put(fieldName, fieldValue);
                }
            }

            // Verify VNPAY secure hash
            String vnp_SecureHash = request.getParameter("vnp_SecureHash");
            if (fields.containsKey("vnp_SecureHashType")) {
                fields.remove("vnp_SecureHashType");
            }
            if (fields.containsKey("vnp_SecureHash")) {
                fields.remove("vnp_SecureHash");
            }
            String signValue = Config.hashAllFields(fields);
            if (signValue.equals(vnp_SecureHash)) {
                String vnp_Amount = request.getParameter("vnp_Amount");
                String vnp_TxnRef = request.getParameter("vnp_TxnRef");
                String vnp_TransactionStatus = request.getParameter("vnp_TransactionStatus");
                boolean transSuccess = "00".equals(vnp_TransactionStatus); // Xác định transSuccess trực tiếp từ vnp_TransactionStatus

                long amount = Long.parseLong(vnp_Amount) / 100;

                // Forward to result page with transaction details
                request.setAttribute("transResult", transSuccess);
                request.setAttribute("txnRef", vnp_TxnRef);
                request.setAttribute("amount", amount);
                request.getRequestDispatcher("/vnpay_jsp/paymentResult.jsp").forward(request, response);
            } else {
                System.out.println("GD KO HOP LE (invalid signature)");
                response.sendRedirect("error.jsp");
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Handles VNPAY return and forwards to paymentResult.jsp";
    }
}