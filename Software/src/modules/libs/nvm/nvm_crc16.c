#include <stddef.h>
#include <stdint.h>

uint16_t nvm_crc16(const void *data, size_t size)
{
    const uint8_t *bytes = data;
    uint16_t crc = 0xFFFFU;

    for (size_t i = 0U; i < size; ++i)
    {
        crc ^= (uint16_t)bytes[i] << 8U;

        for (uint8_t bit = 0U; bit < 8U; ++bit)
        {
            if ((crc & 0x8000U) != 0U)
            {
                crc = (uint16_t)((crc << 1U) ^ 0x1021U);
            }
            else
            {
                crc <<= 1U;
            }
        }
    }

    return crc;
}