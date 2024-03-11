//
// LessonCellProtocol
// Created by Kamila Sultanova on 16.01.2024.
// Copyright © 2024 Drevmass. All rights reserved.
//

import Foundation

protocol LessonCellProtocol: AnyObject {
    func didSelectLesson(_ lesson: CourseDetail.Lesson)
}
