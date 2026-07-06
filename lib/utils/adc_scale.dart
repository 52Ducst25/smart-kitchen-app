/// Cảm biến khí MQ-4 (gas) & MQ-2 (khói) xuất giá trị ADC thô 0..4095.
/// App hiển thị dạng % thang đo cho dễ đọc, nhưng Firebase/firmware vẫn dùng
/// giá trị ADC thô — nên mọi quy đổi tập trung ở đây (DRY).
const int kAdcMax = 4095;

/// ADC (0..4095) → % thang đo (0..100), làm tròn.
int adcToPercent(num adc) => (adc / kAdcMax * 100).round().clamp(0, 100);

/// % thang đo (0..100) → ADC thô (0..4095) để ghi xuống Firebase.
int percentToAdc(num percent) =>
    (percent / 100 * kAdcMax).round().clamp(0, kAdcMax);
