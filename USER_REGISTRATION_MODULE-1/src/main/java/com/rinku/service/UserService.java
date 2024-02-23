package com.rinku.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.rinku.entity.User;
import com.rinku.repo.UserRepository;

/**
 * Service class to perform business logic that would use in controller.
 * 
 * @author gopinath.biswal
 */
@Service
public class UserService {
	private static final Logger logger = LoggerFactory.getLogger(UserService.class);
	
    @Autowired
    private UserRepository userRepository;

    public boolean registerUser(User user) {
        try {
        	userRepository.save(user);
            return true;
        } catch (Exception e) {
        	logger.error("An error occurred in while registration: {}", e.getMessage(), e);
            return false;
        }
    }
   
    public User findByEmail(String email) {
        return userRepository.findByEmail(email);
    }

	public List<User> getAllUsers() {
		return userRepository.findAll();
	}
	
	public void updateUser(User user) {
		User existingUser = userRepository.findById(user.getId()).orElse(null);
	    if (existingUser != null) {
	        user.setRegistrationNo(existingUser.getRegistrationNo());
	        userRepository.save(user);
	    } else {
	        throw new IllegalArgumentException("User not found with ID: " + user.getId());
	    }
    }

	public void deleteUserById(Long id) {
		userRepository.deleteById(id);
		
	}
}
