package com.restaurant.restaurantmanager.model;

public class User {
    private int id;
    private String username;
    private String password;
    private String roleName;
    private boolean active;

    public User() {}

    public User(int id, String username, String password, String roleName, boolean active) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.roleName = roleName;
        this.active = active;
    }

    public int getId() { return id; }
    public String getUsername() { return username; }
    public String getPassword() { return password; }
    public String getRoleName() { return roleName; }
    public boolean isActive() { return active; }

    public void setId(int id) { this.id = id; }
    public void setUsername(String username) { this.username = username; }
    public void setPassword(String password) { this.password = password; }
    public void setRoleName(String roleName) { this.roleName = roleName; }
    public void setActive(boolean active) { this.active = active; }
}
