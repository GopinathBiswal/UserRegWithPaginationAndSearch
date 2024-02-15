package com.rinku.repo;

import org.springframework.data.jpa.repository.JpaRepository;

import com.rinku.entity.User;

public interface UserRepository extends JpaRepository<User, Long> {
	User findByEmail(String email);
}
