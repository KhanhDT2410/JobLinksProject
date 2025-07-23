package controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import dao.TaskDAO;
import dao.CategoryDAO;
import dao.ReviewDAO;
import model.Task;
import model.Category;
import model.Review;

public class HomeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private TaskDAO taskDAO;
    private CategoryDAO categoryDAO;
    private ReviewDAO reviewDAO;

    @Override
    public void init() throws ServletException {
        try {
            taskDAO = new TaskDAO();
            categoryDAO = new CategoryDAO();
            reviewDAO = new ReviewDAO();
            System.out.println("HomeServlet - DAOs initialized successfully");
        } catch (Exception e) {
            throw new ServletException("Unable to initialize DAOs", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Task> recommendedTasks = new ArrayList<>();
        List<Category> categories = new ArrayList<>();
        List<Review> reviews = new ArrayList<>();
        String error = null;

        try {
            // Lấy filter tìm kiếm
            String searchKeyword = request.getParameter("search");
            String location = request.getParameter("location");
            String budgetMinStr = request.getParameter("budgetMin");
            String budgetMaxStr = request.getParameter("budgetMax");
            Double budgetMin = (budgetMinStr != null && !budgetMinStr.trim().isEmpty()) ? Double.parseDouble(budgetMinStr) : 10000.0;
            Double budgetMax = (budgetMaxStr != null && !budgetMaxStr.trim().isEmpty()) ? Double.parseDouble(budgetMaxStr) : 50000000.0;
            String categoryIdStr = request.getParameter("categoryId");
            Integer categoryId = (categoryIdStr != null && !categoryIdStr.trim().isEmpty()) ? Integer.parseInt(categoryIdStr) : null;

            // Lấy task
            if (searchKeyword != null || location != null || budgetMin != null || budgetMax != null || categoryId != null) {
                recommendedTasks = taskDAO.getRecommendedTasksWithFilters(searchKeyword, location, budgetMin, budgetMax, categoryId);
            } else {
                recommendedTasks = taskDAO.getRecommendedTasks();
            }

            // Lấy category
            categories = categoryDAO.getAllCategories();

            // Lấy review
            reviews = reviewDAO.getAllReviews();
            System.out.println("Review count: " + (reviews != null ? reviews.size() : 0));

            // Gửi filter (giữ nguyên nếu user search)
            request.setAttribute("search", searchKeyword);
            request.setAttribute("location", location);
            request.setAttribute("budgetMin", budgetMinStr);
            request.setAttribute("budgetMax", budgetMaxStr);
            request.setAttribute("categoryId", categoryIdStr);

        } catch (Exception e) {
            error = "Lỗi hệ thống: " + e.getMessage();
            e.printStackTrace();
        }

        // Gửi dữ liệu
        request.setAttribute("recommendedTasks", recommendedTasks != null ? recommendedTasks : new ArrayList<>());
        request.setAttribute("categories", categories != null ? categories : new ArrayList<>());
        request.setAttribute("reviews", reviews != null ? reviews : new ArrayList<>());
        request.setAttribute("error", error);

        request.getRequestDispatcher("/home.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
