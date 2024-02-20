package com.rinku.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.rinku.entity.User;
import com.rinku.repo.UserRepository;

@Service
public class UserService {
    @Autowired
    private UserRepository userRepository;

//    public User registerUser(User user) {
//        return userRepository.save(user);
//    }
    
    public boolean registerUser(User user) {
        try {
            userRepository.save(user);
            return true;
        } catch (Exception e) {
            e.getMessage();
            return false;
        }
    }
   
    public User findByEmail(String email) {
        return userRepository.findByEmail(email);
    }
}
