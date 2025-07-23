package controller;

import dao.ReviewDAO;
import model.Review;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/reviews")
public class ReviewServlet extends HttpServlet {
    private ReviewDAO reviewDAO;

    @Override
    public void init() throws ServletException {
        reviewDAO = new ReviewDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            List<Review> reviews = reviewDAO.getAllReviews();
            System.out.println("Number of reviews retrieved in servlet: " + (reviews != null ? reviews.size() : 0));
            request.setAttribute("reviews", reviews != null ? reviews : new ArrayList<Review>());
            request.getRequestDispatcher("/home.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Servlet error: " + e.getMessage());
            request.setAttribute("error", "Đã xảy ra lỗi khi tải danh sách đánh giá: " + e.getMessage());
            request.getRequestDispatcher("/home.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Chuyển hướng yêu cầu POST về phương thức doGet
        doGet(request, response);
    }
}