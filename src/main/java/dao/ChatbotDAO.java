
package dao;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.Map;
import jakarta.servlet.ServletContext;

public class ChatbotDAO {
    private static final String FILE_PATH = "/WEB-INF/Chatbot Document.xlsx";

    public static String getResponse(String userMessage, ServletContext context) {
        Map<String, String> responses = new LinkedHashMap<>();
        String realPath = context.getRealPath(FILE_PATH);
        System.out.println("Đường dẫn thật đến file: " + realPath);

        if (realPath == null || realPath.isEmpty()) {
            return "Lỗi: Không thể xác định đường dẫn tệp Excel!";
        }

        try (FileInputStream fis = new FileInputStream(realPath);
             Workbook workbook = new XSSFWorkbook(fis)) {

            Sheet sheet = workbook.getSheetAt(0);
            if (sheet == null) {
                return "Lỗi: Sheet không tồn tại trong tệp Excel!";
            }

            for (Row row : sheet) {
                if (row.getRowNum() == 0) continue; // Bỏ qua tiêu đề
                Cell triggerCell = row.getCell(0);
                Cell descriptionCell = row.getCell(1);
                if (triggerCell != null && descriptionCell != null) {
                    String trigger = triggerCell.getStringCellValue().trim().toLowerCase();
                    String description = descriptionCell.getStringCellValue().trim();
                    responses.put(trigger, description);
                }
            }

        } catch (IOException e) {
            return "Lỗi khi đọc tệp Excel: " + e.getMessage();
        }

        // Chuyển message người dùng về chữ thường để so sánh
        String msg = userMessage.toLowerCase();

        for (Map.Entry<String, String> entry : responses.entrySet()) {
            if (msg.contains(entry.getKey())) {
                return entry.getValue(); // Trả về description nếu message chứa trigger
            }
        }

        return "Tôi không hiểu bạn đang hỏi gì. Bạn có thể nói rõ hơn không?";
    }
}
