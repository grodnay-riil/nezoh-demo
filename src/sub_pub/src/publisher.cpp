#include <rclcpp/rclcpp.hpp>
#include <std_msgs/msg/string.hpp>
#include <string>

int main(int argc, char *argv[])
{
    rclcpp::init(argc, argv);
    auto node = rclcpp::Node::make_shared("publisher");
    auto publisher = node->create_publisher<std_msgs::msg::String>("large_topic", 10);

    std_msgs::msg::String message;
    message.data = std::string(4000, 'c');  // Large message with 4000 'c'

    rclcpp::Rate rate(10);
    while (rclcpp::ok()) {
        publisher->publish(message);
        RCLCPP_INFO(node->get_logger(), "Publishing large message of size: %ld bytes", message.data.size());
        rate.sleep();
    }

    rclcpp::shutdown();
    return 0;
}
