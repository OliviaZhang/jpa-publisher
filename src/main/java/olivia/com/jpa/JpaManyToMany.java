package olivia.com.jpa;

import java.util.Date;

import javax.transaction.Transactional;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import olivia.com.jpa.model.Book;
import olivia.com.jpa.model.Publisher;
import olivia.com.jpa.model.BookPublisher;
import olivia.com.jpa.repository.BookRepository;
import olivia.com.jpa.repository.PublisherRepository;

@SpringBootApplication
public class JpaManyToMany implements CommandLineRunner {
	private static final Logger logger = LoggerFactory.getLogger(JpaManyToMany.class);
	
	@Autowired
	private BookRepository bookRepository;
	
	@Autowired
	private PublisherRepository publisherRepository;
	
	public static void main(String[] args) {
		SpringApplication.run(JpaManyToMany.class, args);
	}
	
	@Override
	@Transactional
	public void run(String... strings) throws Exception {
		Book bookA = new Book("Book A");
		
		Publisher publisherA = new Publisher("Publisher A");
		
		BookPublisher bookPublisher = new BookPublisher();
		
		bookPublisher.setBook(bookA);
		bookPublisher.setPublisher(publisherA);
		bookPublisher.setPublishedDate(new Date());
		bookA.getBookPublishers().add(bookPublisher);
		
		publisherRepository.save(publisherA);
		bookRepository.save(bookA);
		
		System.out.println(bookA.getBookPublishers().size());
		
//		bookA.getBookPublishers().remove(bookPublisher);
//		bookRepository.save(bookA);
//		
//		System.out.println(bookA.getBookPublishers().size());
	}
}
