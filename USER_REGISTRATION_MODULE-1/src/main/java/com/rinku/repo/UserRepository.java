package com.rinku.repo;

import org.springframework.data.jpa.repository.JpaRepository;

import com.rinku.entity.User;

/**
 * Repository to connect db operation with the help of JPA.
 * 
 * @author gopinath.biswal
 */
public interface UserRepository extends JpaRepository<User, Long> {
	User findByEmail(String email);
}
