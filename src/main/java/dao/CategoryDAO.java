package dao;

import model.Category;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

public class CategoryDAO {
    private final DBContext dbContext;
    private static final Logger LOGGER = Logger.getLogger(CategoryDAO.class.getName());

    public CategoryDAO() {
        dbContext = new DBContext();
    }

    public List<Category> getAllCategories() throws SQLException {
        List<Category> categories = new ArrayList<>();
        ResultSet rs = null;

        try {
            rs = dbContext.getData("SELECT * FROM categories");
            while (rs.next()) {
                Category category = new Category();
                category.setCategoryId(rs.getInt("category_id"));
                category.setName(rs.getString("name"));
                categories.add(category);
                LOGGER.info("L?y danh m?c: ID=" + category.getCategoryId() + ", Name=" + category.getName());
            }
            LOGGER.info("T?ng s? danh m?c: " + categories.size());
        } catch (SQLException e) {
            LOGGER.severe("L?i khi l?y danh sách danh m?c: " + e.getMessage());
            throw e;
        } finally {
            dbContext.closeResources(null, rs);
        }

        return categories;
    }

    public Category getCategoryById(int categoryId) throws SQLException {
        Category category = null;
        ResultSet rs = null;

        try {
            rs = dbContext.getData("SELECT category_id, name FROM categories WHERE category_id = ?", categoryId);
            if (rs.next()) {
                category = new Category();
                category.setCategoryId(rs.getInt("category_id"));
                category.setName(rs.getString("name"));
                LOGGER.info("Tìm th?y category: ID=" + categoryId + ", Name=" + category.getName());
            } else {
                LOGGER.warning("Không tìm th?y category v?i ID: " + categoryId);
            }
        } catch (SQLException e) {
            LOGGER.severe("L?i khi l?y category v?i ID " + categoryId + ": " + e.getMessage());
            throw e;
        } finally {
            dbContext.closeResources(null, rs);
        }
        return category;
    }
}