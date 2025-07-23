package dao;

import java.sql.Timestamp;
import java.util.HashMap;
import java.util.Map;

public class TaskBoostManager {
    private static TaskBoostManager instance;
    private final Map<Integer, Timestamp> boostedTasks;

    private TaskBoostManager() {
        boostedTasks = new HashMap<>();
    }

    public static synchronized TaskBoostManager getInstance() {
        if (instance == null) {
            instance = new TaskBoostManager();
        }
        return instance;
    }

    public void boostTask(int taskId) {
        boostedTasks.put(taskId, new Timestamp(System.currentTimeMillis()));
    }

    public Timestamp getBoostedAt(int taskId) {
        return boostedTasks.get(taskId);
    }

    public void removeBoost(int taskId) {
        boostedTasks.remove(taskId);
    }
}