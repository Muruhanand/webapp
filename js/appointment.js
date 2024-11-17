var today = new Date();
var minDate = new Date(today);
minDate.setDate(today.getDate() + 3);
var maxDate = new Date(today);
maxDate.setMonth(today.getMonth() + 3);

var minDateStr = minDate.toISOString().split('T')[0];
var maxDateStr = maxDate.toISOString().split('T')[0];

document.getElementById('dateSelector').setAttribute('min', minDateStr);
document.getElementById('dateSelector').setAttribute('max', maxDateStr);



function populateServices() {
    var categorySelect = document.getElementById("categoryOptions");
    var serviceSelect = document.getElementById("serviceOptions");
    var selectedCategory = categorySelect.value;

    // Clear existing options
    serviceSelect.innerHTML = "";

    // Populate new options
    if (servicesByCategory[selectedCategory]) {
        servicesByCategory[selectedCategory].forEach(function(service) {
            var option = document.createElement("option");
            option.value = service[0];
            option.text = service[1];
            serviceSelect.appendChild(option);
        });
    }
}