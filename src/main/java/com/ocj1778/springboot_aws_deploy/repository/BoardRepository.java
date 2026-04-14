package com.ocj1778.springboot_aws_deploy.repository;

import com.ocj1778.springboot_aws_deploy.entity.Board;
import org.springframework.data.jpa.repository.JpaRepository;

public interface BoardRepository extends JpaRepository<Board, Long> {
}
