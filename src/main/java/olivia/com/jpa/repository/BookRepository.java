package olivia.com.jpa.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import olivia.com.jpa.model.Book;

public interface BookRepository extends JpaRepository<Book, Integer> {

}
