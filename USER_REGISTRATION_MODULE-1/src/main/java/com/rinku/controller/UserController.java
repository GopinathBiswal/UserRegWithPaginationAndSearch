package com.rinku.controller;
 
import java.nio.charset.StandardCharsets;
import java.security.DigestException;
import java.security.MessageDigest;
import java.util.Arrays;
import java.util.Base64;
import java.util.List;
import java.util.Random;

import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.rinku.entity.User;
import com.rinku.repo.UserRepository;
import com.rinku.service.UserService;

import jakarta.mail.internet.MimeMessage;

/**
 * Controller for crud and OTP operation with mail.
 * 
 * @author gopinath.biswal
 */
@Controller
public class UserController {
    @Autowired
    private UserService userService;
    
    @Autowired
	private JavaMailSender javaMailSender;
    
    @Autowired
    private UserRepository userRepository;
     
    @GetMapping("/register")
    public String showRegistrationForm(Model model) {
        model.addAttribute("user", new User());
        return "register";
    }

//    @PostMapping("/register")
//    public String registerUser(User user) {
//        userService.registerUser(user);
//        return "redirect:/registrationSuccess"; // Redirect to a success page
//    }
    
    @PostMapping("/register")
    @ResponseBody
    public ResponseEntity<String> registerUser(User user) {
    	
    	try {
    		if(user.getUserName()!=null && !user.getUserName().isEmpty()) {
				String encryptText=decryptPassword(user.getUserName());
				String decryptText = getDecryptText(encryptText);
				user.setUserName(decryptText);
			}
			if(user.getMobileNumber()!=null && !user.getMobileNumber().isEmpty()) {
				String encryptText=decryptPassword(user.getMobileNumber());
				String decryptText = getDecryptText(encryptText);
				user.setMobileNumber(decryptText);
			}
			if(user.getEmail()!=null && !user.getEmail().isEmpty()) {
				String encryptText=decryptPassword(user.getEmail());
				String decryptText = getDecryptText(encryptText);
				user.setEmail(decryptText);
			}
    		
    		if (userService.registerUser(user)) {
            	String registrationNumber = generateRegistrationNumber(user.getId());
                user.setRegistrationNo(registrationNumber);
                userRepository.save(user);
                return ResponseEntity.ok("success:"+registrationNumber); 
            }
		} catch (Exception e) {
			e.printStackTrace();
		}
    	return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("error"); 
    }
    
    private String generateRegistrationNumber(Long userId) {
        String formattedId = String.format("%05d", userId);
        return "USERREGNO/" + formattedId;
    }

//    @GetMapping("/registrationSuccess")
//    public String showRegistrationSuccessPage() {
//        return "registrationSuccess";
//    }
    
    @GetMapping("/login")
    public String showLoginPage() {
        return "login";
    }

    @PostMapping("/generate-otp")
    public ResponseEntity<String> generateOTP(@RequestParam("email") String email) {
        // Check if the email is registered
        User user = userService.findByEmail(email);
        if (user != null) {
            // Generate OTP
            String otp = generateOTP();
            // Send OTP to the email
            sendOTPByEmail(email, otp);
            return ResponseEntity.ok(otp); // Return OTP value in the response body
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Email not found. Please register first.");
        }
    }
    
    @PostMapping("/verify-email") // Handle email verification
    public ResponseEntity<String> verifyEmail(@RequestParam("email") String email) {
        User user = userService.findByEmail(email);
        if (user != null) {
            return ResponseEntity.ok("true"); // Email exists
        } else {
            return ResponseEntity.ok("false"); // Email does not exist
        }
    }

    // Method to generate a random 6-digit OTP
    private String generateOTP() {
        Random random = new Random();
        int otp = 100000 + random.nextInt(900000);
        return String.valueOf(otp);
    }

    // Method to send OTP to the registered email
    public void sendOTPByEmail(String email, String otp) {
     
    	try {
        	MimeMessage message = javaMailSender.createMimeMessage();
        	MimeMessageHelper helper = new MimeMessageHelper(message);
        	
        	helper.setFrom("1998bgopinath@gmail.com");
        	helper.setTo(email);
        	helper.setSubject("Your OTP for registration");
        	helper.setText("Your OTP is: " + otp);
        	
        	javaMailSender.send(message);
        } catch (Exception e) {
            e.printStackTrace();
        }
        
    }

    @PostMapping("/verify-otp")
    public String verifyOTP(@RequestParam("otp") String otp, @RequestParam("email") String email, RedirectAttributes redirectAttributes) {
        // Add logic to verify OTP here
        if (otpIsValid(otp)) {
            redirectAttributes.addFlashAttribute("success", "OTP verified successfully!");
        } else {
            redirectAttributes.addFlashAttribute("error", "Invalid OTP. Please try again.");
        }
        return "redirect:/login";
    }

    // Method to validate OTP (dummy implementation, replace with your actual logic)
    private boolean otpIsValid(String otp) {
        // Dummy implementation: OTP is valid if it's a 6-digit number
        return otp != null && otp.matches("\\d{6}");
    }
    
    @PostMapping("/login")
    public String login(@RequestParam("email") String email, Model model) {
        // Assuming you have a UserService that retrieves user information
        User user = userService.findByEmail(email);
        if (user != null) {
            model.addAttribute("username", user.getUserName());
            return "welcome"; // Redirect to the welcome page
        } else {
            // Handle invalid login, such as displaying an error message
            return "login"; // Redirect back to the login page
        }
    }
    
    @GetMapping("/show-records")
    public String showRecords(Model model) {
        List<User> users = userService.getAllUsers();
        model.addAttribute("users", users);
        
        return "showRecords";
    }
    
    @PostMapping("/update")
    public ResponseEntity<String> updateRecord(@RequestBody User user) {
    	try {
            userService.updateUser(user);
            return ResponseEntity.ok("Record updated successfully");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                                 .body("Failed to update record: " + e.getMessage());
        }
    }
    
    @PostMapping("/delete")
    public ResponseEntity<String> deleteRecord(@RequestParam("id") Long id) {
        try {
        	userService.deleteUserById(id);
            return ResponseEntity.ok("Record deleted successfully");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                                 .body("Failed to delete record: " + e.getMessage());
        }
    }
    
    private String getDecryptText(String cipherText) {
		String secret = "f8e0c592d34ecd5bda95bc21cebc15ac";
		String decryptedText =null;
		try {
			byte[] cipherData = Base64.getDecoder().decode(cipherText);
			
			byte[] saltData = Arrays.copyOfRange(cipherData, 8, 16);
	 
			MessageDigest md5 = MessageDigest.getInstance("MD5");
			final byte[][] keyAndIV = GenerateKeyAndIV(32, 16, 1, saltData, secret.getBytes(StandardCharsets.UTF_8), md5);
			SecretKeySpec key = new SecretKeySpec(keyAndIV[0], "AES");
			IvParameterSpec iv = new IvParameterSpec(keyAndIV[1]);
	 
			byte[] encryptedData = Arrays.copyOfRange(cipherData, 16, cipherData.length);
			Cipher aesCBC = Cipher.getInstance("AES/CBC/PKCS5Padding");
			aesCBC.init(Cipher.DECRYPT_MODE, key, iv);
			byte[] decryptedData = aesCBC.doFinal(encryptedData);
			decryptedText = new String(decryptedData, StandardCharsets.UTF_8);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return decryptedText;
	}
	
	private String decryptPassword(String encryptedPass) {
		if (encryptedPass != null && !encryptedPass.isEmpty()) {
	        encryptedPass = encryptedPass.substring(5, encryptedPass.length() - 5);
	        return new String(Base64.getDecoder().decode(encryptedPass));
	    } else
	        return encryptedPass;
	}
	 
	public static byte[][] GenerateKeyAndIV(int keyLength, int ivLength, int iterations, byte[] salt, byte[] password, MessageDigest md) {
		
		Integer digestLength = md.getDigestLength();
		Integer requiredLength = (keyLength + ivLength + digestLength - 1) / digestLength * digestLength;
		byte[] generatedData = new byte[requiredLength];
		int generatedLength = 0;
	 
		try {
	       md.reset();
	       // Repeat process until sufficient data has been generated
	       while (generatedLength < keyLength + ivLength) {
	           // Digest data (last digest if available, password data, salt if available)
	           if (generatedLength > 0)
	               md.update(generatedData, generatedLength - digestLength, digestLength);
	           md.update(password);
	           if (salt != null)
	               md.update(salt, 0, 8);
	           md.digest(generatedData, generatedLength, digestLength);
	 
	           // additional rounds
	           for (Integer i = 1; i < iterations; i++) {
	               md.update(generatedData, generatedLength, digestLength);
	               md.digest(generatedData, generatedLength, digestLength);
	           }
	           generatedLength += digestLength;
	       }
	 
	       // Copy key and IV into separate byte arrays
	       byte[][] result = new byte[2][];
	       result[0] = Arrays.copyOfRange(generatedData, 0, keyLength);
	       if (ivLength > 0)
	           result[1] = Arrays.copyOfRange(generatedData, keyLength, keyLength + ivLength);
	 
	       return result;
	 
	   } catch (DigestException e) {
	       throw new RuntimeException(e);
	 
	   } finally {
	       // Clean out temporary data
	       Arrays.fill(generatedData, (byte)0);
	   }
	}

} //Class closing
