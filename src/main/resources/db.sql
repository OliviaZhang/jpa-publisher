CREATE DATABASE  IF NOT EXISTS `jpa_manytomany_extracolumns` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `jpa_manytomany_extracolumns`;

--
-- Table structure for table `book`
--

DROP TABLE IF EXISTS `book`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `book` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `publisher`
--

DROP TABLE IF EXISTS `publisher`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `publisher` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8;

--
-- Table structure for table `book_publisher`
--

DROP TABLE IF EXISTS `book_publisher`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `book_publisher` (
  `book_id` int(10) unsigned NOT NULL,
  `publisher_id` int(10) unsigned NOT NULL,
  `published_date` datetime DEFAULT NULL,
  PRIMARY KEY (`book_id`,`publisher_id`),
  KEY `fk_bookpublisher_publisher_idx` (`publisher_id`),
  CONSTRAINT `fk_bookpublisher_book` FOREIGN KEY (`book_id`) REFERENCES `book` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_bookpublisher_publisher` FOREIGN KEY (`publisher_id`) REFERENCES `publisher` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
Define JPA Entities

JPA Entity is defined with @Entity annotation, represent a table in your database.

src/main/java/com/hellokoding/jpa/model/Book.java

package com.hellokoding.jpa.model;

import javax.persistence.*;
import java.util.HashSet;
import java.util.Set;

@Entity
public class Book{
    private int id;
    private String name;
    private Set<BookPublisher> bookPublishers;

    public Book() {
    }

    public Book(String name) {
        this.name = name;
        bookPublishers = new HashSet<>();
    }

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @OneToMany(mappedBy = "book", cascade = CascadeType.ALL, orphanRemoval = true)
    public Set<BookPublisher>   getBookPublishers() {
        return bookPublishers;
    }

    public void setBookPublishers(Set<BookPublisher> bookPublishers) {
        this.bookPublishers = bookPublishers;
    }
}
src/main/java/com/hellokoding/jpa/model/Publisher.java

package com.hellokoding.jpa.model;

import javax.persistence.*;
import java.util.Set;

@Entity
public class Publisher {
    private int id;
    private String name;
    private Set<BookPublisher> bookPublishers;

    public Publisher(){

    }

    public Publisher(String name){
        this.name = name;
    }

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @OneToMany(mappedBy = "publisher")
    public Set<BookPublisher> getBookPublishers() {
        return bookPublishers;
    }

    public void setBookPublishers(Set<BookPublisher> bookPublishers) {
        this.bookPublishers = bookPublishers;
    }
}
src/main/java/com/hellokoding/jpa/model/BookPublisher.java

package com.hellokoding.jpa.model;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;

@Entity
@Table(name = "book_publisher")
public class BookPublisher implements Serializable{
    private Book book;
    private Publisher publisher;
    private Date publishedDate;

    @Id
    @ManyToOne
    @JoinColumn(name = "book_id")
    public Book getBook() {
        return book;
    }

    public void setBook(Book book) {
        this.book = book;
    }

    @Id
    @ManyToOne
    @JoinColumn(name = "publisher_id")
    public Publisher getPublisher() {
        return publisher;
    }

    public void setPublisher(Publisher publisher) {
        this.publisher = publisher;
    }

    @Column(name = "published_date")
    public Date getPublishedDate() {
        return publishedDate;
    }

    public void setPublishedDate(Date publishedDate) {
        this.publishedDate = publishedDate;
    }
}
@Table maps the entity with the table. If no @Table is defined, the default value is used: the class name of the entity.

@Id declares the identifier property of the entity.

@Column maps the entity's field with the table's column. If @Column is omitted, the default value is used: the field name of the entity.

@ManyToOne defines a many-to-one relationship between 2 entities. @JoinColumn indicates the entity is the owner of the relationship: the corresponding table has a column with a foreign key to the referenced table. mappedBy indicates the entity is the inverse of the relationship.

Spring Data JPA Repository

Spring Data JPA contains some built-in Repository implemented some common functions to work with database: findOne, findAll, save,...All we need for this example is extend it.

src/main/java/com/hellokoding/jpa/repository/BookRepository.java

package com.hellokoding.jpa.repository;

import com.hellokoding.jpa.model.Book;
import org.springframework.data.jpa.repository.JpaRepository;

public interface BookRepository extends JpaRepository<Book, Integer>{
}
src/main/java/com/hellokoding/jpa/repository/PublisherRepository.java

package com.hellokoding.jpa.repository;

import com.hellokoding.jpa.model.Publisher;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PublisherRepository extends JpaRepository<Publisher, Integer> {
}
Application Properties

src/main/resources/application.properties

spring.datasource.url=jdbc:mysql://localhost/jpa_manytomany_extracolumns
spring.datasource.username=hellokoding
spring.datasource.password=hellokoding
spring.datasource.driver-class-name=com.mysql.jdbc.Driver

spring.jpa.show-sql=true
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQL5Dialect
Run the application

src/main/java/com/hellokoding/jpa/HelloJpaApplication.java

package com.hellokoding.jpa;

import com.hellokoding.jpa.model.Book;
import com.hellokoding.jpa.model.BookPublisher;
import com.hellokoding.jpa.model.Publisher;
import com.hellokoding.jpa.repository.BookRepository;
import com.hellokoding.jpa.repository.PublisherRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import javax.transaction.Transactional;
import java.util.Date;

@SpringBootApplication
public class HelloJpaApplication implements CommandLineRunner {
    private static final Logger logger = LoggerFactory.getLogger(HelloJpaApplication.class);

    @Autowired
    private BookRepository bookRepository;

    @Autowired
    private PublisherRepository publisherRepository;

    public static void main(String[] args) {
        SpringApplication.run(HelloJpaApplication.class, args);
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

        // test
        System.out.println(bookA.getBookPublishers().size());

        // update
        bookA.getBookPublishers().remove(bookPublisher);
        bookRepository.save(bookA);

        // test
        System.out.println(bookA.getBookPublishers().size());
    }
}
You can run the application using mvn spring-boot:run, JPA will insert data into book, publisher and book_publisher tables.

Source code

git@github.com:hellokoding/jpa-manytomany-extracolumns-springboot-maven-mysql.git

https://github.com/hellokoding/jpa-manytomany-extracolumns-springboot-maven-mysql


JPA Many-To-Many Extra Columns Example Brothers:
- JPA Many-To-Many Extra Columns Relationship Mapping Example with Spring Boot, HSQL
- JPA Many-To-Many Extra Columns Relationship Mapping Example with Spring Boot, Maven and MySQL
HelloPersistenceJPAJavaSpring BootMySQL
Giau Ngo's Picture
Giau Ngo
Java. JavaScript
 
Giau Ngo - 21 October 2015
JPA Many-To-Many Relationship Mapping Example with Spring Boot, Maven and MySQL
HelloPersistenceJPAJavaSpring BootMySQL
Giau Ngo - 21 February 2016
Registration and Login Example with Spring MVC, Spring Security, Spring Data JPA, XML Configuration, Maven, JSP and MySQL
AuthSecurityJavaSpring MVCMVCJPAMySQL
Comments


Recent Stories
Hello Single Sign On (SSO) Example with JSON Web Token (JWT), Cookie, Spring Boot
Hacker News App with React Native
Todo App with React Native, Realm
Uploading Multiple Files Example with Spring Boot
Follow Us
 Ad
Latest Tweets
Follow on Twitter